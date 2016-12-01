import java.awt.Desktop;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.logging.Level;
import java.util.logging.Logger;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.RadioButton;
import javafx.scene.control.ScrollPane;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import javafx.stage.FileChooser;
import javafx.stage.Screen;
import javafx.stage.Stage;

public final class UnixProjectUI extends Application {
	private final double SCREEN_HEIGHT = Screen.getPrimary().getVisualBounds().getHeight();
	private final double SCREEN_WIDTH = Screen.getPrimary().getVisualBounds().getWidth();
	private final String TEMP_FILE_NAME = File.separator + "temp";
	private Desktop desktop = Desktop.getDesktop();
	private File inputFile;
	private static TextArea ta = new TextArea();
	private ToggleGroup group = new ToggleGroup();
	private TextField keysTf = new TextField();
	private TextField cryptedKeyTf = new TextField();

	@Override
	public void start(final Stage stage) {
		stage.setTitle("Enosh & Zuki Project");
		double paneWidth = SCREEN_WIDTH / 2;
		double paneHeight = SCREEN_HEIGHT / 2;
		final FileChooser fileChooser = new FileChooser();
		final Button openButton = new Button("Select a File...");
		final Button encryptButton = new Button("Go!");
		final Text enterKey = new Text("Enter 8 characters long key:");
		final PasswordField  keyField = new PasswordField();
		final Text enterRsaKeys = new Text("Enter RSA Keys:");
		
		final Text enterCryptedKey = new Text("Enter crypted Key:");
		
		enterKey.setVisible(false);
		keyField.setVisible(false);

		RadioButton rb1 = new RadioButton("Encrypt");
		rb1.setUserData(true);
		rb1.setToggleGroup(group);

		RadioButton rb2 = new RadioButton("Decrypt");
		rb2.setUserData(false);
		rb2.setSelected(true);
		rb2.setToggleGroup(group);

		rb2.setOnAction(e->{
			enterRsaKeys.setVisible(true);
			keysTf.setVisible(true);
			enterCryptedKey.setVisible(true);
			cryptedKeyTf.setVisible(true);
			enterKey.setVisible(false);
			keyField.setVisible(false);
		});
		rb1.setOnAction(e->{
			enterRsaKeys.setVisible(false);
			keysTf.setVisible(false);
			enterCryptedKey.setVisible(false);
			cryptedKeyTf.setVisible(false);
			enterKey.setVisible(true);
			keyField.setVisible(true);
		});
		openButton.setOnAction(e -> {
			inputFile = fileChooser.showOpenDialog(stage);
			if (inputFile != null) {
				printToTextAreaConsole(inputFile.getAbsolutePath() + " is loaded!");
				// encryptButton.setDisable(false);
			}
		});
		keyField.setOnAction(e -> {
			if (keyField.getText().length() != 8) {
				printToTextAreaConsole("Wrong key size!!");
				
			} else {
				printToTextAreaConsole("Valid Key Inseted");
				
			}
		});
		encryptButton.setOnAction(e -> {
			try {
				if((boolean)group.getSelectedToggle().getUserData()){
					String key = keyField.getText();
					runDesScript(inputFile, key, (boolean) group.getSelectedToggle().getUserData());
					runRSAScript(key, true);
					openFile(inputFile);
				}else{
					String key = runRSAScript(cryptedKeyTf.getText(), false);
					runDesScript(inputFile, key, (boolean)group.getSelectedToggle().getUserData());
					openFile(inputFile);
				}
			} catch (Exception e1) {
				e1.printStackTrace();
			}

		});
		// String perlScript = "C:\\perl_test\\test111.pl";

		// runScript(perlScript);
		final HBox hbox = new HBox(12);
		hbox.getChildren().addAll(openButton, encryptButton, enterKey, keyField);
		final HBox rbhbox = new HBox(12);
		rbhbox.getChildren().addAll(rb1, rb2);
		final HBox rsahbox = new HBox(12);
		rsahbox.getChildren().addAll(enterRsaKeys, keysTf,enterCryptedKey,cryptedKeyTf);
		
		final VBox rootGroup = new VBox(12);
		Scene scene = new Scene(new ScrollPane(rootGroup), paneWidth, paneHeight);
		ta.setPrefWidth(scene.getWidth() - scene.getWidth() * 0.05);
		ta.setPrefHeight(scene.getHeight() - scene.getHeight() * 0.15);
		rootGroup.getChildren().addAll(hbox,rsahbox, rbhbox, new ScrollPane(ta));
		rootGroup.setPadding(new Insets(12, 12, 12, 12));

		stage.setScene(scene);
		stage.show();
	}

	private static void printToTextAreaConsole(String txt) {
		Platform.runLater(() -> ta.appendText(txt + "\n"));
	}


	private void runDesScript(File inputFile, String key, boolean isEncrypt) throws IOException, InterruptedException {
		String filePath = inputFile.getAbsolutePath();
		String tempFilePath = inputFile.getParent() + TEMP_FILE_NAME;
		printToTextAreaConsole("Starting DES");
		String perlScript = "/Users/enoshcohen/Dropbox/School/Afeka/3rd year/UNIX/Final Project/DES.pl";
		int encrypt = isEncrypt ? 1 : 0;
		Process p = new ProcessBuilder("perl", perlScript, filePath, tempFilePath, key, Integer.toString(encrypt))
				.start();
		addPrintToConsole(p);
		p.waitFor();
		File encryptedFile = new File(tempFilePath);
		Files.copy(encryptedFile.toPath(), inputFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
		printToTextAreaConsole("Done...");
	}
	
	private String runRSAScript( String text ,boolean isEncrypt) throws IOException, InterruptedException {
		printToTextAreaConsole("Starting RSA");
		String perlScript = "/Users/enoshcohen/Dropbox/School/Afeka/3rd year/UNIX/Final Project/RSA.pl";
		String genKeyPath = "/Users/enoshcohen/Dropbox/School/Afeka/3rd year/UNIX/Final Project/genKey.pl";
		int encrypt = isEncrypt ? 1 : 0;
		String key;
		if(isEncrypt)
		{
			Process genKey = new ProcessBuilder("/usr/local/bin/perl5.24.0", genKeyPath).redirectError(Redirect.INHERIT).start();
			key = addPrintToConsole(genKey);
			genKey.waitFor();
		}else{
			key = keysTf.getText();
		}
		Process rsa = new ProcessBuilder(
				"/usr/local/bin/perl5.24.0", perlScript, Integer.toString(encrypt), key , text)
		.redirectError(Redirect.INHERIT).start();
		String out = addPrintToConsole(rsa);
		rsa.waitFor();
		
		printToTextAreaConsole("Done...");
		return out;
	}

	private static String addPrintToConsole(Process rsa) throws IOException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(rsa.getInputStream()));
		StringBuilder builder = new StringBuilder();
		String line = null;
		while ((line = reader.readLine()) != null) {
			builder.append(line);
			builder.append(System.getProperty("line.separator"));
		}
		String result = builder.toString();
		printToTextAreaConsole(result);
		return result;
	}

	private void openFile(File file) {
		try {
			desktop.open(file);
		} catch (IOException ex) {
			Logger.getLogger(UnixProjectUI.class.getName()).log(Level.SEVERE, null, ex);
		}
	}

	public static void main(String[] args) throws IOException, InterruptedException {
		Application.launch(args);
	}
}