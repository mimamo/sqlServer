USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_Max]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSNote_Max] @Table varchar(20), @Level varchar(20) As
Select Max(nID) From Snote Where sTablename = @Table And sLevelName = @Level
GO
