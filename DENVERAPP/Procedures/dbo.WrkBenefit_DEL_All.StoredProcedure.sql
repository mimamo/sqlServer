USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkBenefit_DEL_All]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkBenefit_DEL_All] as
       Delete from WrkBenefit
GO
