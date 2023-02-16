#[no_mangle]
pub extern "C" fn _main() -> nix::libc::c_int{
    println!("From binary entrypoint 😲");
    0
}

#[no_mangle]
pub unsafe extern "C" fn fork_exec() -> nix::libc::pid_t {
    if let nix::unistd::ForkResult::Parent { child } = nix::unistd::fork().unwrap() {
        return child.as_raw();
    }
    let mut dl_info = nix::libc::Dl_info {
        dli_fname: std::ptr::null_mut(),
        dli_fbase: std::ptr::null_mut(),
        dli_sname: std::ptr::null_mut(),
        dli_saddr: std::ptr::null_mut(),
    };
    if nix::libc::dladdr(fork_exec as *const nix::libc::c_void, &mut dl_info) == 0 {
        panic!("dladdr {}", nix::errno::errno());
    }

    let path = std::ffi::CStr::from_ptr(dl_info.dli_fname);
    #[allow(unreachable_code)]
    match nix::unistd::execv::<&std::ffi::CStr>(path, &[]).unwrap() {}
}

#[no_mangle]
pub extern "C" fn call_me_maybe() {
    println!("Hey, this is crazy but here's my number so...")
}
