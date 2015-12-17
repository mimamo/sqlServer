USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_PORelease_CalcAdj_Count]    Script Date: 12/16/2015 15:55:30 ******/
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
