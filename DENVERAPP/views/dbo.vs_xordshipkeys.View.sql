USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vs_xordshipkeys]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_xordshipkeys] AS SELECT * FROM DENVERSYS..xordshipkeys
GO
