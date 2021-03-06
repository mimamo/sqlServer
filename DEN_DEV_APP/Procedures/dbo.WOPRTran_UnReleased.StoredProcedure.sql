USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPRTran_UnReleased]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPRTran_UnReleased]

AS
   SELECT      *
   FROM     PRTran
   WHERE    EmpID LIKE '%' and
         TimeShtFlg = 1 and
         WrkLocID LIKE '%' and
         EarnDedID LIKE '%' and
         PC_Status = '1'
   ORDER BY    EmpID, TimeShtFlg, Rlsed, Paid, WrkLocID, EarnDedID
GO
