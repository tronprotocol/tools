package org.tron.utils;

import com.beust.jcommander.Parameter;
import lombok.Getter;

public class CommonParameter {

  @Getter
  @Parameter(names = {"-d", "--output-directory"}, description = "Directory")
  private String outputDirectory = "output-directory";
}
