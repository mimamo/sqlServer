USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_PoType]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[EDDataElement_PoType] @parm1 varchar(15)  AS Select  * from EDDataelement where segment = 'BEG' and position = '02' and code like @parm1 order by segment, position, code
GO
