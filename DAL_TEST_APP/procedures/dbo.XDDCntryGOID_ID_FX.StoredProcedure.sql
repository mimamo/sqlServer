USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCntryGOID_ID_FX]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDCntryGOID_ID_FX]
	@CpnyID		varchar( 10 ),
	@Acct 		varchar( 10 ),
	@Sub 		varchar( 24 ),
	@ISOCntry		varchar( 2 )
AS
  	Select 		GatewayOperID, DestCntryCuryID, FXIndicator
  	from 		XDDCntryGOID (nolock)
  	where 		CpnyID = @CpnyID
  				and Acct = @Acct
  				and Sub = @Sub
  				and ISOCntry = @ISOCntry
GO
