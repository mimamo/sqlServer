USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDDepositor_XDDFileFormat]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDDepositor_XDDFileFormat]
	@CustID		varchar( 15 )
AS
	SELECT		*
	FROM 		XDDDepositor D (nolock) LEFT OUTER JOIN XDDFileFormat F (nolock)
                	ON D.FormatID = F.FormatID
	WHERE		D.VendID = @CustID
			and D.VendCust = 'C'
GO
