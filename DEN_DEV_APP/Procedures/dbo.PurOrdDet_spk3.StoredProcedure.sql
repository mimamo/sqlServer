USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_spk3]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PurOrdDet_spk3] @parm1 varchar (10) , @parm2 int  as
select PoNbr,LineId, User1, User2, User3, User4 from PURORDDET
where    PURORDDET.PONbr   = @parm1
and    PURORDDET.LineId = @parm2
order by PURORDDET.PONbr,
PURORDDET.LineId
GO
