USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineTempTransactionsInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineTempTransactionsInsert]
	(
	@Entity VARCHAR(100)
    , @EntityKey int 
    , @TimeKey uniqueidentifier 
    , @BilledHours decimal(24,4) 
    , @BilledRate money 
    , @AmountBilled money 
    , @BilledService int 
    , @BilledItem int 
    , @BillingComments varchar(2000) 
    , @InvoiceLineKey int
    , @NewInvoiceLineKey int
	)
	
AS --Encrypt

	SET NOCOUNT ON

/*
|| When     Who Rel     What
|| 04/19/12 GHL 10.555  Creation for new functionality (saving billed item, billed service, billed comments) 
||                      on the client invoice flex screen
*/

	/* Assume done in vb

	   sSQL = "create table #transaction ( "
            sSQL &= " Entity VARCHAR(100) null "
            sSQL &= ", EntityKey int NULL "
            sSQL &= ", TimeKey uniqueidentifier NULL "
            sSQL &= ", BilledHours decimal(24,4) NULL "
            sSQL &= ", BilledRate money NULL "
            sSQL &= ", AmountBilled money NULL "
            sSQL &= ", BilledService int NULL "
            sSQL &= ", BilledItem int NULL "
            sSQL &= ", BillingComments varchar(2000) NULL " ' will need to go as BilledComment
            sSQL &= ", InvoiceLineKey int null "
            sSQL &= ", NewInvoiceLineKey int null "
            sSQL &= ", ProjectKey int null " ' needed for project rollup
            sSQL &= ", Action varchar(50) null " ' action to perform on the transaction, update, remove or conflict if it is on another invoice
            sSQL &= ", UpdateFlag int null " ' general purpose flag
            sSQL &= ")"

	*/

	insert #transaction (Entity,EntityKey,TimeKey,BilledHours,BilledRate,AmountBilled,BilledService,BilledItem,BillingComments
		,InvoiceLineKey,NewInvoiceLineKey,ProjectKey,Action,UpdateFlag)
	values (@Entity,@EntityKey,@TimeKey,@BilledHours,@BilledRate,@AmountBilled,@BilledService,@BilledItem,@BillingComments
		,@InvoiceLineKey,@NewInvoiceLineKey,NULL,'update',0)

	RETURN 1
GO
