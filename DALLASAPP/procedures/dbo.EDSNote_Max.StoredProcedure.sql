USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_Max]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSNote_Max] @Table varchar(20), @Level varchar(20) As
Select Max(nID) From Snote Where sTablename = @Table And sLevelName = @Level
GO
