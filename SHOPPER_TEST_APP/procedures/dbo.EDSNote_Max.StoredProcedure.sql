USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_Max]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSNote_Max] @Table varchar(20), @Level varchar(20) As
Select Max(nID) From Snote Where sTablename = @Table And sLevelName = @Level
GO
