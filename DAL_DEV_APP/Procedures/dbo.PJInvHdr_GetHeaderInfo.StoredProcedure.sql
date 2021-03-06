USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJInvHdr_GetHeaderInfo]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJInvHdr_GetHeaderInfo]  
		    @DraftNum char(10),
		    @ProjectDesc char(30) OUTPUT, 
		    @Biller char(10) OUTPUT, 
		    @CustomerName char(30) OUTPUT
as
BEGIN
	SET NOCOUNT ON

	DECLARE @Project_BillWith char(16)

	SET @ProjectDesc = ''	
	SET @Biller = ''	

	--Get the projectID and description for the project that the invoice will be billed to
	--Also get the name of the customer the invoice is associasted to
	SELECT @Project_BillWith = inv.project_billwith, @ProjectDesc = pj.project_desc, @CustomerName = cs.Name
	FROM PJInvHdr inv
	INNER JOIN PJProj pj ON inv.project_billwith = pj.project
	INNER JOIN Customer cs ON inv.customer = cs.CustId
	WHERE draft_num = @DraftNum


	--If an entiry exists in PJBill for project passed in, use the biller in PJBill as the biller
	SELECT @Biller = biller	FROM PJBill WHERE Project = @Project_BillWith
	if(ltrim(rtrim(@Biller)) = '')
		BEGIN
		--use the project manager (manager1) of the project in PJProj
		SELECT @Biller = manager1 FROM PJProj WHERE Project = @Project_BillWith
		END
	
END
GO
