USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDMCB_APDoc_Vendor]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDMCB_APDoc_Vendor]
	@BatNbr		    varchar( 10 ),
	@RefNbr			varchar( 10 )

AS
    Select 		* 
    FROM APDoc D (nolock) LEFT OUTER JOIN Vendor V (nolock)
    			ON D.VendID = V.VendID
    WHERE  		BatNbr = @BatNbr
    			and RefNbr LIKE @RefNbr
    ORDER BY  	RefNbr
GO
