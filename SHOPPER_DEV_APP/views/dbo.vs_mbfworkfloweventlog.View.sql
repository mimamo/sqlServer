USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vs_mbfworkfloweventlog]    Script Date: 12/21/2015 14:33:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_mbfworkfloweventlog] AS SELECT * FROM DEN_DEV_SYS..mbfworkfloweventlog
GO
