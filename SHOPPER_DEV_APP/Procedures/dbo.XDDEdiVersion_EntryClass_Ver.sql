USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEdiVersion_EntryClass_Ver]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEdiVersion_EntryClass_Ver] @parm1 varchar(4), @parm2 varchar(6) AS
  Select * from XDDEdiVersion where EntryClass = @parm1 and
  EDIVersion LIKE @parm2
  ORDER by EntryClass, EDIVersion
GO
