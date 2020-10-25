import static java.awt.event.KeyEvent.*;

import processing.awt.PSurfaceAWT;

import javax.swing.JFileChooser;
import javax.swing.JFrame;
import java.io.File;

PVector spawn, pos, size;

ArrayList<PVector> shapes = new ArrayList();

boolean mousePressing;

void setup() {
  size(1280, 720);

  noStroke();
  fill(#1B0028);
}

void draw() {
  background(64);

  for (int i = 0; i < shapes.size() / 2; i++)
    rect(shapes.get(i * 2 + 0).x, shapes.get(i * 2 + 0).y, 
      shapes.get(i * 2 + 1).x, shapes.get(i * 2 + 1).y);

  if (mousePressing) {
    size = new PVector(mouseX, mouseY).sub(pos);
    rect(pos.x, pos.y, abs(size.x), abs(size.y));
  }
}

void keyReleased() {
  if (keyCode == VK_DELETE) {
    shapes.remove(shapes.size() - 1);
    shapes.remove(shapes.size() - 1);
  }
}

void mousePressed() {
  if (mouseButton == 0) {
    pos = new PVector(mouseX, mouseY);
    mousePressing = true;
  }
}

void mouseReleased() {
  if (mouseButton == 0) {
    mousePressing = false;

    shapes.add(pos);
    shapes.add(size);
  } else if (mouseButton == 1) {
    spawn = new PVector(mouseX, mouseY);
  }
}

void exit() {
  save();

  super.exit();
}

void save() {
  JFileChooser fileChooser = new JFileChooser();
  fileChooser.setDialogTitle("Save Map As...");
  try {
    fileChooser.setCurrentDirectory(new File(PApplet.class.getProtectionDomain().getCodeSource().getLocation().toURI()));
  } 
  catch (Exception e) {
  }
  if (fileChooser.showOpenDialog(((PSurfaceAWT.SmoothCanvas) ((PSurfaceAWT) surface).getNative()).getFrame()) == JFileChooser.APPROVE_OPTION) {
    File selectedFile = fileChooser.getSelectedFile();
    save(selectedFile.getAbsolutePath());
  }
}

void save(String filepath) {
  PrintWriter out = createWriter(filepath);

  out.append(String.format("spawn %.2f %.2f", 
    spawn.x, spawn.y));

  for (int i = 0; i < shapes.size() / 2; i++)
    out.append(String.format("wall %.2f %.2f %.2f %.2f\n", 
      abs(shapes.get(i * 2 + 0).x), abs(shapes.get(i * 2 + 0).y), 
      abs(shapes.get(i * 2 + 1).x), abs(shapes.get(i * 2 + 1).y)));

  out.flush();
  out.close();
}
