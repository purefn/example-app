with (import ./.);

pkgs.mkShell {
  buildInputs = with pkgs; [
    terraform
    aws-vault
  ];
}
