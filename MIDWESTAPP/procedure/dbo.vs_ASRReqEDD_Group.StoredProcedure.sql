USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[vs_ASRReqEDD_Group]    Script Date: 12/21/2015 15:55:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vs_ASRReqEDD_Group] @parm1 varchar(2), @parm2 int
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS
	SELECT *
	FROM vs_ASRReqEDD
	WHERE DocType = @parm1 and EDDGroup = @parm2
	ORDER BY Doctype, EDDGroup
GO
