USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSegDef]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PSegDef    Script Date: 4/17/98 12:50:25 PM ******/
Create Proc [dbo].[PSegDef] @CLASSID varchar ( 3)             , @SEGNBR varchar ( 2)             , @SEGID varchar ( 24)               as
select * from segdef where FieldClass like @CLASSID and SegNumber like @SEGNBR and ID like @SEGID order by FieldClass, SegNumber, ID
GO
