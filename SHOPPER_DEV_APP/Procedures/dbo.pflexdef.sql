USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pflexdef]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pflexdef    Script Date: 4/17/98 12:50:25 PM ******/
Create Proc [dbo].[pflexdef] @CLASSID varchar ( 3)              as
select * from flexdef where fieldclass like @CLASSID order by FieldClass
GO
