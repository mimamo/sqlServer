USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_PerPost_AP_PV]    Script Date: 12/21/2015 16:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_PerPost_AP_PV]
  	@PerPost	varchar( 6 ),
  	@VendID		varchar( 15 ),
  	@BatNbr		varchar( 10 )
AS

	declare @Query 	varchar( 255 )  
  
	select @Query = 'Select * from XDD_vs_CEM_PV Where PerPost >= ''' + @PerPost + ''' and VendID = ''' + @VendID + ''' and BatNbr LIKE ''' + @BatNbr + ''' order by BatNbr DESC'
-- print @Query
	execute(@Query)
GO
