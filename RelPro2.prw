#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function RelPro2
    Relatorio PSAY com cabeçalho
    @type  Function
    @author Vinicius Silva
    @since 03/04/2023
/*/
User Function RelPro2()
    Local cTitulo    := "Informações dos Produtos Cadastrados"

    //? Variáveis para o SetPrint
    Private cNomeRel := "PSAY"
    Private cAlias   := "SB1"
    Private cProgram := "RelPro2"
    Private cDesc1   := "Relatório da Tabela de Produtos"
    Private cSize    := "M"
    Private m_pag    := 1
    
    //? Variáveis para o SetDefault
    Private aReturn  := {"Zebrado", 1, "Administração", 1, 2, "", "", 1}

    cNomeRel := SetPrint(cAlias, cProgram,,  @cTitulo, cDesc1, , , .F.,,.T., cSize,, .F.)

    SetDefault(aReturn, cAlias)

    RptStatus({|| Print(cTitulo)}, cTitulo)
Return 

Static Function Print(cTitulo)
    Local cCabec := "CÓDIGO                   DESCRIÇÃO                          UN. MED.      PREÇO          ARMAZÉM"
    Local nLinha := 8 
    Local aColunas	 := {}
	
	Aadd(aColunas, 001)
	Aadd(aColunas, 025)
	Aadd(aColunas, 062)
	Aadd(aColunas, 075)
	Aadd(aColunas, 093)

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))

    Cabec(cTitulo, cCabec, "", , cSize)

    while !EOF()
        @ nLinha, aColunas[1] PSAY PADR(AllTrim(SB1->B1_COD), 20) 

        @ nLinha, aColunas[2] PSAY PADR(AllTrim(SB1->B1_DESC), 41) 

        @ nLinha, aColunas[3] PSAY PADR(AllTrim(SB1->B1_UM), 10)

        if SB1->B1_PRV1 == 0
            @ nLinha, aColunas[4] PSAY PADR("R$0,00", 10)
        else
            @ nLinha, aColunas[4] PSAY PADR(AllTrim(cValToChar(SB1->B1_PRV1)), 10) 
        endif

        @ nLinha, aColunas[5] PSAY PADR(AllTrim(SB1->B1_LOCPAD), 10)

        nLinha++
        @ nLinha, 00 PSAY Replicate("-", 134)
        nLinha++ 

        SB1->(DbSkip())
    end

    SET DEVICE TO SCREEN 

    if aReturn[5] == 1 
        SET PRINTER TO DbCommitAll()
        OurSpool(cNomeRel)   
    endif

    MS_FLUSH()
Return
