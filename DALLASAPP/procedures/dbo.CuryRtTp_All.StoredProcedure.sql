USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[CuryRtTp_All]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CuryRtTp_All    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc [dbo].[CuryRtTp_All] @parm1 varchar ( 6) as
    Select * from CuryRtTp where RateTypeId like @parm1 order by RateTypeId
GO
