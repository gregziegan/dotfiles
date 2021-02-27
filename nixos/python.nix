{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    python3Env = python3.withPackages (ps: with ps; [
      # black
      csvkit
      ipython
      jupyterlab
      numpy
      pandas
      pandocfilters
      pdfx
      pip
      pygraphviz
      pylint
      scikitlearn
      seaborn
      setuptools
      virtualenvwrapper # for pip
    ]);
  };
}
