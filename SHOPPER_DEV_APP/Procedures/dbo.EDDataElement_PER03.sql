USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_PER03]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_PER03] @parm1 varchar(15) as select *  from EDDataElement where segment = 'PER' and position = '03' and code like @parm1 order by segment, position, code
GO
