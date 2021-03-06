USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCntryGOID_All]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDCntryGOID_All]
	@CpnyID		varchar( 10 ),
	@Acct 		varchar( 10 ),
	@Sub 		varchar( 24 ),
	@ISOCntry		varchar( 2 )
AS
  	Select 		*
  	from 		XDDCntryGOID
  	where 		CpnyID LIKE @CpnyID
  				and Acct like @Acct
  				and Sub like @Sub
  				and ISOCntry like @ISOCntry
  	ORDER by 		CpnyID, Acct, Sub, ISOCntry
GO
