USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDistType_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDistType_All    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDistType_All]
@Parm1 varchar ( 8) AS
SELECT * FROM Budget_Dist_Type WHERE DistType LIKE @Parm1 ORDER BY DistType
GO
