USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vs_messages]    Script Date: 12/21/2015 15:55:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_messages] AS SELECT * FROM DENVERSYS..messages
GO
