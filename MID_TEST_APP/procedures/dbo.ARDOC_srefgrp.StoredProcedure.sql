USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_srefgrp]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARDOC_srefgrp] @parm1 varchar (10) , @parm2 varchar (10)   as
select sum(docbal) from ardoc
Where
ardoc.batnbr = @parm1 and
ardoc.refnbr like @parm2
Group by ardoc.batnbr
order by ardoc.batnbr
GO
