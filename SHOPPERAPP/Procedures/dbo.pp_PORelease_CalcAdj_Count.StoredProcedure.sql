USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_PORelease_CalcAdj_Count]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[pp_PORelease_CalcAdj_Count]
    @BatNbr VARCHAR (10)

as

Select Count(*)
       From vp_PORelease_Intran_TotQty v
               Join ItemSite S
                  On v.InvtId = s.InvtId
                 And v.SiteId = s.SiteId
       Where S.QtyOnHand < 0
         And v.Qty >= Abs(S.QtyOnHand)
         And v.BatNbr = @BatNbr
         And v.Rlsed = 0
         And v.Jrnltype = 'PO'
GO
