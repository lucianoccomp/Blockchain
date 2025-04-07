// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

struct Campanha {

	// Em solidity, as varíaveis são sempre 
	// inicializadas por um valor padrão
	// defaut: 0
	address Autor;
	//defaut ""
	string Titulo;
	//defaut ""
	string Descricao;
	//defaut ""
	string VideoUrl;
	//defaut ""
	string ImagemUrl;
	//defaut 0
	uint256 Saldo;
	//defaut false
	bool Ativo;
	
}

contract DonateCrypto {
	
	// Inteiro sem sinal
	uint256 public taxa = 100;
	uint256 public proximoId = 0;
	
	// id=> campanha
	mapping(uint256 => Campanha) public Campanhas;
	
	//calldata = dado temporátio somente para leitura
	function AddCampanha(string calldata titulo, string calldata descricao, string calldata videoUrl, string calldata imagemUrl) public {
	
		Campanha memory novaCampanha;
		novaCampanha.Titulo = titulo;
		novaCampanha.Descricao = descricao;
		novaCampanha.VideoUrl = videoUrl;
		novaCampanha.ImagemUrl = imagemUrl;
		novaCampanha.Ativo = true;
		novaCampanha.Autor = msg.sender;	
		proximoId++;
		
		Campanhas[proximoId] = novaCampanha;
	}

    // arg id é o id da campanha
    function Doacao(uint256 id) public payable {
			
		require(msg.value > 0, "You must send a donation value > 0");
		require(Campanhas[id].Ativo == true, "Cannot donate to this campaign");
		
		Campanhas[id].Saldo += msg.value;
	}

    //arg id da campanha
	function Saque(uint256 id) public {
		
		Campanha memory campanha = Campanhas[id];
		require(campanha.Autor == msg.sender, "You do not have permission.");
		require(campanha.Ativo == true, "This campaign is closed.");
		require(campanha.Saldo > taxa, "This campaign does not have enough balance.");
		
		
		address payable recebedor = payable(campanha.Autor);
		recebedor.call{value: campanha.Saldo - taxa}("");
		
		Campanhas[id].Ativo = false;
	}

}

