USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[GetProcSource]    Script Date: 12/21/2015 15:42:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GetProcSource    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.GetProcSource    Script Date: 4/7/98 12:56:04 PM ******/
---SYSTEMTABLE
--- This Stored Proc needs to go in both system & App db
Create Proc  [dbo].[GetProcSource] @parm1 varchar(32) as
Select text from syscomments where id = object_id( @parm1) order by colid
GO
