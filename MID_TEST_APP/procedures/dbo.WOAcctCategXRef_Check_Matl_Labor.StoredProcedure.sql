USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOAcctCategXRef_Check_Matl_Labor]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOAcctCategXRef_Check_Matl_Labor]
AS
	Set NoCount On

	Declare	@MatlAcct	varchar( 16 )
	Declare @LaborAcct	varchar( 16 )

	Select 	@MatlAcct = Material_Acct
	FROM	WOSetup (nolock)

	Select 	@LaborAcct = Labor_Acct
	FROM	WOSetup (nolock)

	-- We should at least have two records in WOAcctCategXRef
	-- matching the WOSetup table's Matl/Labor acct
	select	case when count(*) >= 2
		then 1
		else 0
		end
	from	WOAcctCategXRef (nolock)
	where	Acct = @MatlAcct
		or Acct = @LaborAcct
GO
