USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkBenefit_DEL_All]    Script Date: 12/21/2015 16:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkBenefit_DEL_All] as
       Delete from WrkBenefit
GO
