USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vs_registitem]    Script Date: 12/21/2015 16:00:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_registitem] AS SELECT * FROM DENVERSYS..registitem
GO
