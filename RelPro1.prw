#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function RelPro1
    Relatorio PSAY sem cabeçalho
    @type  Function
    @author Vinicius Silva
    @since 03/04/2023
/*/
User Function RelPro1()
    Local cTitulo    := "Informações dos Produtos Cadastrados"

    //? Variáveis para o SetPrint
    Private cNomeRel := "PSAY"
    Private cAlias   := "SB1"
    Private cProgram := "RelPro1"
    Private cDesc1   := "Relatório da Tabela de Produtos"
    Private cSize    := "M"
    
    //? Variáveis para o SetDefault
    Private aReturn  := {"Zebrado", 1, "Administração", 1, 2, "", "", 1}

    cNomeRel := SetPrint(cAlias, cProgram,,  @cTitulo, cDesc1, , , .F.,,.T., cSize,, .F.)

    SetDefault(aReturn, cAlias)

    RptStatus({|| Imprime()}, cTitulo, "Gerando Relatório...")
Return 

Static Function Imprime()
    Local nLinha := 2 
    Local nCont  := 0

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))

    while !EOF()
        nCont++ 

        @ ++nLinha, 00 PSAY PADR("Código: ", 10) + AllTrim(SB1->B1_COD)

        @ ++nLinha, 00 PSAY PADR("Descrição: ", 10) + AllTrim(SB1->B1_DESC)

        @ ++nLinha, 00 PSAY PADR("Un. Med: ", 10) + AllTrim(SB1->B1_UM)

        if Empty(SB1->B1_PRV1)
            @ ++nLinha, 00 PSAY PADR("Preço: ", 10) + "R$0,00"
        else
            @ ++nLinha, 00 PSAY PADR("Preço: ", 10) + AllTrim(cValToChar(SB1->B1_PRV1))
        endif

        @ ++nLinha, 00 PSAY PADR("Armazém: ", 10) + AllTrim(SB1->B1_LOCPAD)

        @ ++nLinha, 00 PSAY Replicate("-", 50)

        //? Para deixar 10 produtos em uma página
        if nCont == 10
            nCont  := 0
            nLinha := 2
        endif

        SB1->(DbSkip())
    end

    SET DEVICE TO SCREEN 

    if aReturn[5] == 1 //* Define o tipo de impressão: se é em disco (1), se é spool e etc
        SET PRINTER TO DbCommitAll()
        OurSpool(cNomeRel)   
    endif

    MS_FLUSH()
Return
