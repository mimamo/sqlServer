USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pflexdef]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pflexdef    Script Date: 4/17/98 12:50:25 PM ******/
Create Proc [dbo].[pflexdef] @CLASSID varchar ( 3)              as
select * from flexdef where fieldclass like @CLASSID order by FieldClass
GO
