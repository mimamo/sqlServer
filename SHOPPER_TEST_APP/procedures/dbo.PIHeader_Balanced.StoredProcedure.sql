USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIHeader_Balanced]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIHeader_Balanced    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[PIHeader_Balanced] @parm1 varchar(10) As
    select * from piheader
    where piid like @parm1 and status = 'B'
    order by piid desc
GO
