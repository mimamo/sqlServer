USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_CheckmultiLineref]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[EDSOShipLine_CheckmultiLineref]
  @CpnyId varchar(10), @shipperid varchar(15),@Invtid varchar(30)
AS Declare @cnt int, @LineRef varchar(5)
--select count
Select @Cnt = count(*) from soshipline where cpnyid = @cpnyid and shipperid = @ShipperId and invtid = @invtid
If @Cnt > 1
  Begin
      Select @LineRef = '-1'
    goto exitproc
  end
Else
  begin
  Select @LineRef = lineref  from soshipline where cpnyid = @cpnyid and shipperid = @ShipperId and invtid = @invtid
  end
Exitproc:
Select @LineRef
GO
