USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCntryGOID_All]    Script Date: 12/21/2015 13:36:00 ******/
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
