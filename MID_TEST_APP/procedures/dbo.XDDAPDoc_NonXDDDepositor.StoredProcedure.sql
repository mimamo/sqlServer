USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPDoc_NonXDDDepositor]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAPDoc_NonXDDDepositor]
   	@BatNbr		varchar(10)

AS
	-- It's a computer batch if no Vendors are in XDDDepositor (records that are not voided)
   	SELECT       	C.Acct, C.Sub, X.PPFormatID
   	FROM		APDoc C (nolock) right outer join APAdjust A (nolock)
			ON C.Acct = A.AdjgAcct and C.Sub = A.AdjgSub and C.DocType = A.AdjgDoctype 
				and C.RefNbr = A.AdjgRefNbr and A.AdjgDocType <> 'ZC' LEFT OUTER JOIN APDoc V (nolock)
			ON A.VendID = V.VendID and A.AdjdDoctype = V.DocType and A.AdjdRefNbr = V.RefNbr LEFT JOIN XDDDepositor D (nolock)
   			ON C.VendID = D.Vendid LEFT OUTER JOIN XDDBank X (nolock)
   			ON C.CpnyID = X.CpnyID and C.Acct = X.Acct and C.Sub = X.Sub LEFT OUTER JOIN Batch B (nolock)
   			ON 'AP' = B.Module and C.BatNbr = B.BatNbr
   	WHERE		C.BatNbr = @BatNbr
   			and (D.VendID IS NULL
   			     or (D.VendID Is Not Null and D.VendCust = 'V'
   				 and ((	D.PNStatus = 'N'
				      	or (D.PNStatus = 'P' and GetDate() < D.PNDate)
				      	or D.Status <> 'Y'	-- Inactive
				      	or (D.TermDate <> Convert(SmallDateTime, '01/01/1900') and D.TermDate < GetDate())  -- Today is after termdate
			      	      ) 
			      	      or V.eStatus = ''		-- If eStatus is blank, then Pos Pay regardless
			      	     )
				 )
			    )
   			and C.DocType <> 'VC'
GO
