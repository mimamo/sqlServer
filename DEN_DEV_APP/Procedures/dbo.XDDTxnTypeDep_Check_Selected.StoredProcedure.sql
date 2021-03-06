USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_Check_Selected]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnTypeDep_Check_Selected]
   @FormatID		varchar( 15 ),
   @EStatus		varchar( 1 )

AS

   -- count if in XDDTxnTypeDep as Selected
   --	and CanChange
   --	    or CannotChange, but the EntryClass is the same
   SELECT 	count(*) 
   FROM 	XDDTxnTypeDep T (nolock) LEFT OUTER JOIN XDDDepositor D (nolock)
   		ON T.VendCust = D.VendCust and T.VendID = D.VendID LEFT OUTER JOIN XDDTxnType TT (nolock)
   		ON D.FormatID = TT.FormatID and T.EStatus = TT.EStatus
   WHERE	T.VendCust = 'V'
   		and D.FormatID = @FormatID
   		and T.EStatus = @EStatus
   		and T.Selected = 1
   		and (D.EntryClassCanChg = 1 
   			or (D.EntryClassCanChg = 0 and rtrim(D.EntryClass) = rtrim(TT.EntryClass))
   		    )
GO
