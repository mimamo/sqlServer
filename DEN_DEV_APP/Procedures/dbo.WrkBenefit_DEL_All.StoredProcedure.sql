USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkBenefit_DEL_All]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkBenefit_DEL_All] as
       Delete from WrkBenefit
GO
