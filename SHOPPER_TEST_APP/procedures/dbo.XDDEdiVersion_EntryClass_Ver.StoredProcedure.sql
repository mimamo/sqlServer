USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEdiVersion_EntryClass_Ver]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEdiVersion_EntryClass_Ver] @parm1 varchar(4), @parm2 varchar(6) AS
  Select * from XDDEdiVersion where EntryClass = @parm1 and
  EDIVersion LIKE @parm2
  ORDER by EntryClass, EDIVersion
GO
