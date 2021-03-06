USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[UnionDeduct_DedId_Update2]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[UnionDeduct_DedId_Update2] @parm1 varchar (10), @parm2 varchar (1), @parm3 varchar (2), @parm4 float as
           Update UnionDeduct set basetype        = @parm2,
                                  calcmthd        = @parm3,
                                  fxdpctrate      = @parm4,
                                  wklyminamtperpd = 0,
                                  bwkminamtperpd  = 0,
                                  smonminamtperpd = 0,
                                  monminamtperpd  = 0,
                                  override        = 0
           Where DedId = @parm1 and BaseType <> 'E'
GO
