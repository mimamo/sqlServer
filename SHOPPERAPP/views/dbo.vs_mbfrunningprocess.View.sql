USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vs_mbfrunningprocess]    Script Date: 12/21/2015 16:12:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_mbfrunningprocess] AS SELECT * FROM DENVERSYS..mbfrunningprocess
GO
