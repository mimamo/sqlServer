USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_PER03]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_PER03] @parm1 varchar(15) as select *  from EDDataElement where segment = 'PER' and position = '03' and code like @parm1 order by segment, position, code
GO
