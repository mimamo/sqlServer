USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_spoli]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PurOrdDet_spoli] @parm1 varchar (10) , @parm2 int  as
select * from PURORDDET
where    PURORDDET.PONbr  = @parm1
and    PURORDDET.LineId = @parm2
order by PURORDDET.PONbr,
PURORDDET.LineId
GO
