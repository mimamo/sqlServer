USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_PER01]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[EDDataElement_PER01]  @parm1 varchar(15)  AS Select  * from EDDataElement where segment = 'PER' and position = '01' and code like @parm1 order by segment, position, code
GO
