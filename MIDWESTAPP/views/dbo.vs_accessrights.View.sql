USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vs_accessrights]    Script Date: 12/21/2015 15:55:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_accessrights] AS SELECT * FROM DENVERSYS..accessrights
GO
