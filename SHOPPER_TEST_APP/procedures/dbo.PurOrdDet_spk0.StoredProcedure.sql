USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_spk0]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PurOrdDet_spk0] @parm1 varchar (10) , @parm2 smallint  as
select * from PURORDDET
where    PURORDDET.PONbr   = @parm1
and    PURORDDET.LineNbr = @parm2
order by PURORDDET.PONbr,
PURORDDET.LineNbr
GO
